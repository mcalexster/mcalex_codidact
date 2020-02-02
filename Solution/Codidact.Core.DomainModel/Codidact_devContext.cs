using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace Codidact.Core.WebApplication
{
    public partial class Codidact_devContext : DbContext
    {
        public Codidact_devContext()
        {
        }

        public Codidact_devContext(DbContextOptions<Codidact_devContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Communities> Communities { get; set; }
        public virtual DbSet<Community> Community { get; set; }
        public virtual DbSet<Members> Members { get; set; }
        public virtual DbSet<Question> Question { get; set; }
        public virtual DbSet<QuestionTag> QuestionTag { get; set; }
        public virtual DbSet<Tag> Tag { get; set; }
        public virtual DbSet<TrustLevels> TrustLevels { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseNpgsql("Host=localhost;Database=Codidact_dev;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Communities>(entity =>
            {
                entity.ToTable("communities");

                entity.HasIndex(e => e.Name)
                    .HasName("ix_communities_name")
                    .IsUnique();

                entity.HasIndex(e => e.Url)
                    .HasName("ix_communities_url")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.CreateDateAt)
                    .HasColumnName("create_date_at")
                    .HasDefaultValueSql("'0001-01-01 00:00:00'::timestamp without time zone");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.DeletedAt).HasColumnName("deleted_at");

                entity.Property(e => e.DeletedByMemberId).HasColumnName("deleted_by_member_id");

                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.LastModifiedAt).HasColumnName("last_modified_at");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasColumnName("name")
                    .HasMaxLength(40);

                entity.Property(e => e.Status)
                    .HasColumnName("status")
                    .HasDefaultValueSql("1");

                entity.Property(e => e.Tagline)
                    .IsRequired()
                    .HasColumnName("tagline")
                    .HasMaxLength(100);

                entity.Property(e => e.Url)
                    .IsRequired()
                    .HasColumnName("url")
                    .HasMaxLength(255);
            });

            modelBuilder.Entity<Community>(entity =>
            {
                entity.HasIndex(e => e.Name)
                    .HasName("Community_Name_uq")
                    .IsUnique();

                entity.Property(e => e.Id).UseIdentityAlwaysColumn();

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasMaxLength(50);
            });

            modelBuilder.Entity<Members>(entity =>
            {
                entity.ToTable("members");

                entity.HasIndex(e => e.Email)
                    .HasName("ix_members_email")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.Bio).HasColumnName("bio");

                entity.Property(e => e.CreateDateAt)
                    .HasColumnName("create_date_at")
                    .HasDefaultValueSql("'0001-01-01 00:00:00'::timestamp without time zone");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.DeletedAt).HasColumnName("deleted_at");

                entity.Property(e => e.DeletedByMemberId).HasColumnName("deleted_by_member_id");

                entity.Property(e => e.DisplayName)
                    .IsRequired()
                    .HasColumnName("display_name")
                    .HasMaxLength(100);

                entity.Property(e => e.Email)
                    .IsRequired()
                    .HasColumnName("email")
                    .HasMaxLength(320);

                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.IsEmailVerified).HasColumnName("is_email_verified");

                entity.Property(e => e.IsFromStackExchange).HasColumnName("is_from_stack_exchange");

                entity.Property(e => e.IsSuspended).HasColumnName("is_suspended");

                entity.Property(e => e.LastModifiedAt).HasColumnName("last_modified_at");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.Location).HasColumnName("location");

                entity.Property(e => e.StackExchangeId).HasColumnName("stack_exchange_id");

                entity.Property(e => e.StackExchangeLastImportedAt).HasColumnName("stack_exchange_last_imported_at");

                entity.Property(e => e.StackExchangeValidatedAt).HasColumnName("stack_exchange_validated_at");

                entity.Property(e => e.SuspensionEndAt).HasColumnName("suspension_end_at");
            });

            modelBuilder.Entity<Question>(entity =>
            {
                entity.Property(e => e.Id).UseIdentityAlwaysColumn();

                entity.Property(e => e.Body)
                    .IsRequired()
                    .HasColumnType("character varying");

                entity.Property(e => e.DatetimeCreated)
                    .HasColumnType("timestamp with time zone")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.Title)
                    .IsRequired()
                    .HasMaxLength(255);

                entity.HasOne(d => d.Community)
                    .WithMany(p => p.Question)
                    .HasForeignKey(d => d.CommunityId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Community_fk");
            });

            modelBuilder.Entity<QuestionTag>(entity =>
            {
                entity.HasKey(e => new { e.QuestionId, e.TagId })
                    .HasName("Question_Tag_pk");

                entity.ToTable("Question_Tag");

                entity.HasOne(d => d.Question)
                    .WithMany(p => p.QuestionTag)
                    .HasForeignKey(d => d.QuestionId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Question_fk");

                entity.HasOne(d => d.Tag)
                    .WithMany(p => p.QuestionTag)
                    .HasForeignKey(d => d.TagId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Tag_fk");
            });

            modelBuilder.Entity<Tag>(entity =>
            {
                entity.HasIndex(e => new { e.CommunityId, e.Title })
                    .HasName("Tag_Title_uq")
                    .IsUnique();

                entity.Property(e => e.Id).UseIdentityAlwaysColumn();

                entity.Property(e => e.DatetimeCreated)
                    .HasColumnType("timestamp with time zone")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.Description).HasColumnType("character varying");

                entity.Property(e => e.Title)
                    .IsRequired()
                    .HasMaxLength(40);

                entity.HasOne(d => d.Community)
                    .WithMany(p => p.Tag)
                    .HasForeignKey(d => d.CommunityId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("Community_fk");
            });

            modelBuilder.Entity<TrustLevels>(entity =>
            {
                entity.ToTable("trust_levels");

                entity.HasIndex(e => e.Explanation)
                    .HasName("ix_trust_levels_explanation")
                    .IsUnique();

                entity.HasIndex(e => e.Name)
                    .HasName("ix_trust_levels_name")
                    .IsUnique();

                entity.Property(e => e.Id).HasColumnName("id");

                entity.Property(e => e.CreateDateAt)
                    .HasColumnName("create_date_at")
                    .HasDefaultValueSql("'0001-01-01 00:00:00'::timestamp without time zone");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.Explanation).HasColumnName("explanation");

                entity.Property(e => e.LastModifiedAt).HasColumnName("last_modified_at");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.Name)
                    .IsRequired()
                    .HasColumnName("name")
                    .HasMaxLength(100)
                    .HasDefaultValueSql("''::character varying");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
