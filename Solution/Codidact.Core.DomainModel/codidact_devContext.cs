using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata;

namespace Codidact.Core.WebApplication
{
    public partial class codidact_devContext : DbContext
    {
        public codidact_devContext()
        {
        }

        public codidact_devContext(DbContextOptions<codidact_devContext> options)
            : base(options)
        {
        }

        public virtual DbSet<Category> Category { get; set; }
        public virtual DbSet<CategoryPostType> CategoryPostType { get; set; }
        public virtual DbSet<Comment> Comment { get; set; }
        public virtual DbSet<CommentVote> CommentVote { get; set; }
        public virtual DbSet<Member> Member { get; set; }
        public virtual DbSet<MemberPrivilege> MemberPrivilege { get; set; }
        public virtual DbSet<MemberSocialMediaType> MemberSocialMediaType { get; set; }
        public virtual DbSet<Post> Post { get; set; }
        public virtual DbSet<PostDuplicatePost> PostDuplicatePost { get; set; }
        public virtual DbSet<PostStatus> PostStatus { get; set; }
        public virtual DbSet<PostStatusType> PostStatusType { get; set; }
        public virtual DbSet<PostTag> PostTag { get; set; }
        public virtual DbSet<PostType> PostType { get; set; }
        public virtual DbSet<PostVote> PostVote { get; set; }
        public virtual DbSet<Privilege> Privilege { get; set; }
        public virtual DbSet<Setting> Setting { get; set; }
        public virtual DbSet<SocialMediaType> SocialMediaType { get; set; }
        public virtual DbSet<Tag> Tag { get; set; }
        public virtual DbSet<Template> Template { get; set; }
        public virtual DbSet<TrustLevel> TrustLevel { get; set; }
        public virtual DbSet<VoteType> VoteType { get; set; }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            if (!optionsBuilder.IsConfigured)
            {
#warning To protect potentially sensitive information in your connection string, you should move it out of source code. See http://go.microsoft.com/fwlink/?LinkId=723263 for guidance on storing connection strings.
                optionsBuilder.UseNpgsql("Host=localhost;Database=codidact_dev;");
            }
        }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Category>(entity =>
            {
                entity.ToTable("category");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Calculations)
                    .HasColumnName("calculations")
                    .HasDefaultValueSql("0");

                entity.Property(e => e.ContributesToTrustLevel)
                    .IsRequired()
                    .HasColumnName("contributes_to_trust_level")
                    .HasDefaultValueSql("true");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.DisplayName)
                    .IsRequired()
                    .HasColumnName("display_name");

                entity.Property(e => e.IsPrimary).HasColumnName("is_primary");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.LongExplanation).HasColumnName("long_explanation");

                entity.Property(e => e.ParticipationMinimumTrustLevelId).HasColumnName("participation_minimum_trust_level_id");

                entity.Property(e => e.ShortExplanation).HasColumnName("short_explanation");

                entity.Property(e => e.UrlPart)
                    .HasColumnName("url_part")
                    .HasMaxLength(20);

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.CategoryCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("category_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.CategoryLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("category_last_modified_by_member_fk");

                entity.HasOne(d => d.ParticipationMinimumTrustLevel)
                    .WithMany(p => p.Category)
                    .HasForeignKey(d => d.ParticipationMinimumTrustLevelId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("category_participation_minimum_trust_level_fk");
            });

            modelBuilder.Entity<CategoryPostType>(entity =>
            {
                entity.ToTable("category_post_type");

                entity.HasComment("CategoryPostType");

                entity.HasIndex(e => new { e.CategoryId, e.PostTypeId })
                    .HasName("category_post_type_category_post_type_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CategoryId).HasColumnName("category_id");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.IsActive)
                    .IsRequired()
                    .HasColumnName("is_active")
                    .HasDefaultValueSql("true");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.PostTypeId).HasColumnName("post_type_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.CategoryPostTypeCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("category_post_type_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.CategoryPostTypeLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("category_post_type_last_modified_by_member_fk");
            });

            modelBuilder.Entity<Comment>(entity =>
            {
                entity.ToTable("comment");

                entity.HasComment("Table for the comments on posts, both questions and answers.");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Body)
                    .IsRequired()
                    .HasColumnName("body");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.DeletedAt).HasColumnName("deleted_at");

                entity.Property(e => e.Downvotes).HasColumnName("downvotes");

                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.MemberId).HasColumnName("member_id");

                entity.Property(e => e.NetVotes).HasColumnName("net_Votes");

                entity.Property(e => e.ParentCommentId).HasColumnName("parent_comment_id");

                entity.Property(e => e.PostId).HasColumnName("post_id");

                entity.Property(e => e.Score)
                    .HasColumnName("score")
                    .HasColumnType("numeric");

                entity.Property(e => e.Upvotes).HasColumnName("upvotes");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.CommentCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("comment_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.CommentLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("comment_last_modified_by_member_fk");

                entity.HasOne(d => d.Member)
                    .WithMany(p => p.CommentMember)
                    .HasForeignKey(d => d.MemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("comment_member_fk");

                entity.HasOne(d => d.ParentComment)
                    .WithMany(p => p.InverseParentComment)
                    .HasForeignKey(d => d.ParentCommentId)
                    .HasConstraintName("comment_parent_comment_fk");

                entity.HasOne(d => d.Post)
                    .WithMany(p => p.Comment)
                    .HasForeignKey(d => d.PostId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("comment_post_fk");
            });

            modelBuilder.Entity<CommentVote>(entity =>
            {
                entity.ToTable("comment_vote");

                entity.HasIndex(e => new { e.CommentId, e.MemberId })
                    .HasName("comment_vote_comment_member_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CommentId).HasColumnName("comment_id");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.MemberId).HasColumnName("member_id");

                entity.Property(e => e.VoteTypeId).HasColumnName("vote_type_id");

                entity.HasOne(d => d.Comment)
                    .WithMany(p => p.CommentVote)
                    .HasForeignKey(d => d.CommentId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("commentvote_comment_fk");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.CommentVoteCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("comment_vote_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.CommentVoteLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("comment_vote_last_modified_by_member_fk");

                entity.HasOne(d => d.Member)
                    .WithMany(p => p.CommentVoteMember)
                    .HasForeignKey(d => d.MemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("comment_vote_member_fk");

                entity.HasOne(d => d.VoteType)
                    .WithMany(p => p.CommentVote)
                    .HasForeignKey(d => d.VoteTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("comment_vote_vote_type_fk");
            });

            modelBuilder.Entity<Member>(entity =>
            {
                entity.ToTable("member");

                entity.HasComment("This table will hold the global member records for a Codidact Instance. A member should only have one email to login with, that would be stored here. Does not include details such as password storage and hashing.");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Bio).HasColumnName("bio");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.DisplayName)
                    .IsRequired()
                    .HasColumnName("display_name");

                entity.Property(e => e.IsAdministrator).HasColumnName("is_administrator");

                entity.Property(e => e.IsModerator).HasColumnName("is_moderator");

                entity.Property(e => e.IsSyncedWithNetworkAccount)
                    .IsRequired()
                    .HasColumnName("is_synced_with_network_account")
                    .HasDefaultValueSql("true");

                entity.Property(e => e.IsTemporarilySuspended).HasColumnName("is_temporarily_suspended");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.NetworkAccountId)
                    .HasColumnName("network_account_id")
                    .HasComment("link to 'network_account' table?");

                entity.Property(e => e.ProfilePictureLink).HasColumnName("profile_picture_link");

                entity.Property(e => e.TemporarySuspensionEndAt).HasColumnName("temporary_suspension_end_at");

                entity.Property(e => e.TemporarySuspensionReason).HasColumnName("temporary_suspension_reason");

                entity.Property(e => e.TrustLevelId).HasColumnName("trust_level_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.InverseCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.InverseLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_last_modified_by_member_fk");

                entity.HasOne(d => d.TrustLevel)
                    .WithMany(p => p.Member)
                    .HasForeignKey(d => d.TrustLevelId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_trust_level_fk");
            });

            modelBuilder.Entity<MemberPrivilege>(entity =>
            {
                entity.ToTable("member_privilege");

                entity.HasComment("For recording which members have which privilege in a community. If a member has a privilege suspended, then that is also recorded here, and a nightly task will auto undo the suspension once the privelege_suspension_end_date has passed.");

                entity.HasIndex(e => new { e.MemberId, e.PrivilegeId })
                    .HasName("member_privilege_member_privilege_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.IsSuspended).HasColumnName("is_suspended");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.MemberId).HasColumnName("member_id");

                entity.Property(e => e.PrivilegeId).HasColumnName("privilege_id");

                entity.Property(e => e.PrivilegeSuspensionEndAt).HasColumnName("privilege_suspension_end_at");

                entity.Property(e => e.PrivilegeSuspensionStartAt).HasColumnName("privilege_suspension_start_at");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.MemberPrivilegeCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_privilege_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.MemberPrivilegeLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_privilege_last_modified_by_member_fk");

                entity.HasOne(d => d.Member)
                    .WithMany(p => p.MemberPrivilegeMember)
                    .HasForeignKey(d => d.MemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_privilege_member_fk");

                entity.HasOne(d => d.Privilege)
                    .WithMany(p => p.MemberPrivilege)
                    .HasForeignKey(d => d.PrivilegeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_privilege_privlege_fk");
            });

            modelBuilder.Entity<MemberSocialMediaType>(entity =>
            {
                entity.ToTable("member_social_media_type");

                entity.HasComment("The social media that the member would like to display in their community specific profile");

                entity.HasIndex(e => new { e.MemberId, e.SocialMediaId })
                    .HasName("member_social_media_social_media_member_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Content).HasColumnName("content");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.MemberId).HasColumnName("member_id");

                entity.Property(e => e.SocialMediaId).HasColumnName("social_media_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.MemberSocialMediaTypeCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_social_media_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.MemberSocialMediaTypeLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_social_media_last_modified_by_member_fk");

                entity.HasOne(d => d.Member)
                    .WithMany(p => p.MemberSocialMediaTypeMember)
                    .HasForeignKey(d => d.MemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_social_media_member_fk");

                entity.HasOne(d => d.SocialMedia)
                    .WithMany(p => p.MemberSocialMediaType)
                    .HasForeignKey(d => d.SocialMediaId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("member_social_media_social_media_fk");
            });

            modelBuilder.Entity<Post>(entity =>
            {
                entity.ToTable("post");

                entity.HasComment("I thought about splitting into a Answers table and and QuestionsTable but doing it in the same table lets comments have a PostsId instead of a QuestionsId and a AnswersId. Meta posts are denoted by the IsMeta column. Type of post is determined by the PostTypeId");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Body)
                    .IsRequired()
                    .HasColumnName("body");

                entity.Property(e => e.CategoryId).HasColumnName("category_id");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.Downvotes).HasColumnName("downvotes");

                entity.Property(e => e.IsAccepted).HasColumnName("is_accepted");

                entity.Property(e => e.IsClosed).HasColumnName("is_closed");

                entity.Property(e => e.IsDeleted).HasColumnName("is_deleted");

                entity.Property(e => e.IsProtected).HasColumnName("is_protected");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.MemberId).HasColumnName("member_id");

                entity.Property(e => e.NetVotes)
                    .HasColumnName("net_votes")
                    .HasDefaultValueSql("0");

                entity.Property(e => e.ParentPostId).HasColumnName("parent_post_id");

                entity.Property(e => e.PostTypeId).HasColumnName("post_type_id");

                entity.Property(e => e.Score)
                    .HasColumnName("score")
                    .HasColumnType("numeric");

                entity.Property(e => e.Title)
                    .IsRequired()
                    .HasColumnName("title");

                entity.Property(e => e.Upvotes).HasColumnName("upvotes");

                entity.Property(e => e.Views).HasColumnName("views");

                entity.HasOne(d => d.Category)
                    .WithMany(p => p.Post)
                    .HasForeignKey(d => d.CategoryId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_category_fk");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.PostCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.PostLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_last_modified_by_member_fk");

                entity.HasOne(d => d.Member)
                    .WithMany(p => p.PostMember)
                    .HasForeignKey(d => d.MemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_member_fk");

                entity.HasOne(d => d.ParentPost)
                    .WithMany(p => p.InverseParentPost)
                    .HasForeignKey(d => d.ParentPostId)
                    .HasConstraintName("post_parent_post_fk");

                entity.HasOne(d => d.PostType)
                    .WithMany(p => p.Post)
                    .HasForeignKey(d => d.PostTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_post_type_fk");
            });

            modelBuilder.Entity<PostDuplicatePost>(entity =>
            {
                entity.ToTable("post_duplicate_post");

                entity.HasIndex(e => new { e.OriginalPostId, e.DuplicatePostId })
                    .HasName("post_duplicate_post_original_post_duplicate_post_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.DuplicatePostId).HasColumnName("duplicate_post_id");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.OriginalPostId).HasColumnName("original_post_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.PostDuplicatePostCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_duplicate_post_created_by_member_fk");

                entity.HasOne(d => d.DuplicatePost)
                    .WithMany(p => p.PostDuplicatePostDuplicatePost)
                    .HasForeignKey(d => d.DuplicatePostId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_duplicate_post_duplicate_post_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.PostDuplicatePostLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_duplicate_post_last_modified_by_member_fk");

                entity.HasOne(d => d.OriginalPost)
                    .WithMany(p => p.PostDuplicatePostOriginalPost)
                    .HasForeignKey(d => d.OriginalPostId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_duplicate_post_original_post_fk");
            });

            modelBuilder.Entity<PostStatus>(entity =>
            {
                entity.ToTable("post_status");

                entity.HasIndex(e => new { e.PostId, e.PostStatusTypeId })
                    .HasName("post_status_post_status_type_post_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.PostId).HasColumnName("post_id");

                entity.Property(e => e.PostStatusTypeId).HasColumnName("post_status_type_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.PostStatusCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_status_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.PostStatusLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_status_last_modified_by_member_fk");

                entity.HasOne(d => d.Post)
                    .WithMany(p => p.PostStatus)
                    .HasForeignKey(d => d.PostId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_status_post_id_fk");

                entity.HasOne(d => d.PostStatusType)
                    .WithMany(p => p.PostStatus)
                    .HasForeignKey(d => d.PostStatusTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_status_post_status_type_fk");
            });

            modelBuilder.Entity<PostStatusType>(entity =>
            {
                entity.ToTable("post_status_type");

                entity.HasComment("For setting the status of a post locked/featured etc");

                entity.HasIndex(e => e.DisplayName)
                    .HasName("post_status_display_name_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.Description).HasColumnName("description");

                entity.Property(e => e.DisplayName)
                    .IsRequired()
                    .HasColumnName("display_name");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.PostStatusTypeCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_status_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.PostStatusTypeLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_status_last_modified_by_member_fk");
            });

            modelBuilder.Entity<PostTag>(entity =>
            {
                entity.ToTable("post_tag");

                entity.HasIndex(e => new { e.PostId, e.TagId })
                    .HasName("post_tag_post_tag_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.PostId).HasColumnName("post_id");

                entity.Property(e => e.TagId).HasColumnName("tag_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.PostTagCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_tag_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.PostTagLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_tag_last_modified_by_member_fk");

                entity.HasOne(d => d.Post)
                    .WithMany(p => p.PostTag)
                    .HasForeignKey(d => d.PostId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_tag_post_fk");

                entity.HasOne(d => d.Tag)
                    .WithMany(p => p.PostTag)
                    .HasForeignKey(d => d.TagId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_tag_tag_fk");
            });

            modelBuilder.Entity<PostType>(entity =>
            {
                entity.ToTable("post_type");

                entity.HasComment("Records the type of post, question/answer/blog etc");

                entity.HasIndex(e => e.DisplayName)
                    .HasName("post_type_name_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.Description).HasColumnName("description");

                entity.Property(e => e.DisplayName)
                    .IsRequired()
                    .HasColumnName("display_name");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.PostTypeCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_type_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.PostTypeLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_type_last_modified_by_member_fk");
            });

            modelBuilder.Entity<PostVote>(entity =>
            {
                entity.ToTable("post_vote");

                entity.HasComment("The reason for this table is so that votes by spammers/serial voters can be undone.");

                entity.HasIndex(e => new { e.PostId, e.MemberId })
                    .HasName("post_vote_post_member_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.MemberId).HasColumnName("member_id");

                entity.Property(e => e.PostId).HasColumnName("post_id");

                entity.Property(e => e.VoteTypeId).HasColumnName("vote_type_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.PostVoteCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_vote_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.PostVoteLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_vote_last_modified_by_member_fk");

                entity.HasOne(d => d.Member)
                    .WithMany(p => p.PostVoteMember)
                    .HasForeignKey(d => d.MemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_vote_member_fk");

                entity.HasOne(d => d.Post)
                    .WithMany(p => p.PostVote)
                    .HasForeignKey(d => d.PostId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_vote_post_fk");

                entity.HasOne(d => d.VoteType)
                    .WithMany(p => p.PostVote)
                    .HasForeignKey(d => d.VoteTypeId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("post_vote_vote_type_fk");
            });

            modelBuilder.Entity<Privilege>(entity =>
            {
                entity.ToTable("privilege");

                entity.HasComment("Table for privileges");

                entity.HasIndex(e => e.DisplayName)
                    .HasName("privilege_display_name_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.Description).HasColumnName("description");

                entity.Property(e => e.DisplayName)
                    .IsRequired()
                    .HasColumnName("display_name");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.LastModifiedat)
                    .HasColumnName("last_modifiedat")
                    .HasDefaultValueSql("now()");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.PrivilegeCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("privilege_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.PrivilegeLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("privilege_last_modified_by_member");
            });

            modelBuilder.Entity<Setting>(entity =>
            {
                entity.ToTable("setting");

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.SettingCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("setting_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.SettingLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("setting_last_modified_by_member_fk");
            });

            modelBuilder.Entity<SocialMediaType>(entity =>
            {
                entity.ToTable("social_media_type");

                entity.HasComment("The types of social media that the member can display in their profile");

                entity.HasIndex(e => e.AccountUrl)
                    .HasName("social_media_type_account_url_uc")
                    .IsUnique();

                entity.HasIndex(e => e.DisplayName)
                    .HasName("social_media_type_display_name_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.AccountUrl)
                    .IsRequired()
                    .HasColumnName("account_url");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.DisplayName)
                    .IsRequired()
                    .HasColumnName("display_name");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.SocialMediaTypeCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("social_media_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.SocialMediaTypeLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("social_media_last_modified_by_member_fk");
            });

            modelBuilder.Entity<Tag>(entity =>
            {
                entity.ToTable("tag");

                entity.HasComment("Table for all of the tags");

                entity.HasIndex(e => e.Body)
                    .HasName("tag_body_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.Body)
                    .IsRequired()
                    .HasColumnName("body");

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.Description).HasColumnName("description");

                entity.Property(e => e.IsActive)
                    .IsRequired()
                    .HasColumnName("is_active")
                    .HasDefaultValueSql("true");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.Property(e => e.ParentTagId).HasColumnName("parent_tag_id");

                entity.Property(e => e.SynonymTagId).HasColumnName("synonym_tag_id");

                entity.Property(e => e.TagWiki).HasColumnName("tag_wiki");

                entity.Property(e => e.Usages).HasColumnName("usages");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.TagCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("tag_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.TagLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("tag_last_modified_by_member_fk");

                entity.HasOne(d => d.ParentTag)
                    .WithMany(p => p.InverseParentTag)
                    .HasForeignKey(d => d.ParentTagId)
                    .HasConstraintName("tag_parent_tag_fk");
            });

            modelBuilder.Entity<Template>(entity =>
            {
                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.TemplateCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("<Table>_created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.TemplateLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("<Table>_last_modified_by_member_fk");
            });

            modelBuilder.Entity<TrustLevel>(entity =>
            {
                entity.ToTable("trust_level");

                entity.HasComment("Name for each trust level and an explanation of each that a user should get when they get to that level.");

                entity.HasIndex(e => e.DisplayName)
                    .HasName("trust_level_display_name_uq")
                    .IsUnique();

                entity.HasIndex(e => e.Explanation)
                    .HasName("trust_level_explanation_uq")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.DisplayName)
                    .IsRequired()
                    .HasColumnName("display_name");

                entity.Property(e => e.Explanation)
                    .IsRequired()
                    .HasColumnName("explanation");

                entity.Property(e => e.LastModifedAt)
                    .HasColumnName("last_modifed_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.LastModifiedByMemberId).HasColumnName("last_modified_by_member_id");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.TrustLevelCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("created_by_member_fk");

                entity.HasOne(d => d.LastModifiedByMember)
                    .WithMany(p => p.TrustLevelLastModifiedByMember)
                    .HasForeignKey(d => d.LastModifiedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("last_modified_by_member_fk");
            });

            modelBuilder.Entity<VoteType>(entity =>
            {
                entity.ToTable("vote_type");

                entity.HasComment("Table for the vote types, upvote/downvote.");

                entity.HasIndex(e => e.DisplayName)
                    .HasName("vote_type_display_name_uc")
                    .IsUnique();

                entity.Property(e => e.Id)
                    .HasColumnName("id")
                    .UseIdentityAlwaysColumn();

                entity.Property(e => e.CreatedAt)
                    .HasColumnName("created_at")
                    .HasDefaultValueSql("now()");

                entity.Property(e => e.CreatedByMemberId).HasColumnName("created_by_member_id");

                entity.Property(e => e.DisplayName)
                    .IsRequired()
                    .HasColumnName("display_name");

                entity.Property(e => e.LastModifeidByMemberId).HasColumnName("last_modifeid_by_member_id");

                entity.Property(e => e.LastModifiedAt)
                    .HasColumnName("last_modified_at")
                    .HasDefaultValueSql("now()");

                entity.HasOne(d => d.CreatedByMember)
                    .WithMany(p => p.VoteTypeCreatedByMember)
                    .HasForeignKey(d => d.CreatedByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("vote_type_created_by_member_fk");

                entity.HasOne(d => d.LastModifeidByMember)
                    .WithMany(p => p.VoteTypeLastModifeidByMember)
                    .HasForeignKey(d => d.LastModifeidByMemberId)
                    .OnDelete(DeleteBehavior.ClientSetNull)
                    .HasConstraintName("vote_type_last_modified_by_member_fk");
            });

            OnModelCreatingPartial(modelBuilder);
        }

        partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
    }
}
