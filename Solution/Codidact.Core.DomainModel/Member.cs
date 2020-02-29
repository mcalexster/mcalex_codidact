using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class Member
    {
        public Member()
        {
            CategoryCreatedByMember = new HashSet<Category>();
            CategoryLastModifiedByMember = new HashSet<Category>();
            CategoryPostTypeCreatedByMember = new HashSet<CategoryPostType>();
            CategoryPostTypeLastModifiedByMember = new HashSet<CategoryPostType>();
            CommentCreatedByMember = new HashSet<Comment>();
            CommentLastModifiedByMember = new HashSet<Comment>();
            CommentMember = new HashSet<Comment>();
            CommentVoteCreatedByMember = new HashSet<CommentVote>();
            CommentVoteLastModifiedByMember = new HashSet<CommentVote>();
            CommentVoteMember = new HashSet<CommentVote>();
            InverseCreatedByMember = new HashSet<Member>();
            InverseLastModifiedByMember = new HashSet<Member>();
            MemberPrivilegeCreatedByMember = new HashSet<MemberPrivilege>();
            MemberPrivilegeLastModifiedByMember = new HashSet<MemberPrivilege>();
            MemberPrivilegeMember = new HashSet<MemberPrivilege>();
            MemberSocialMediaTypeCreatedByMember = new HashSet<MemberSocialMediaType>();
            MemberSocialMediaTypeLastModifiedByMember = new HashSet<MemberSocialMediaType>();
            MemberSocialMediaTypeMember = new HashSet<MemberSocialMediaType>();
            PostCreatedByMember = new HashSet<Post>();
            PostDuplicatePostCreatedByMember = new HashSet<PostDuplicatePost>();
            PostDuplicatePostLastModifiedByMember = new HashSet<PostDuplicatePost>();
            PostLastModifiedByMember = new HashSet<Post>();
            PostMember = new HashSet<Post>();
            PostStatusCreatedByMember = new HashSet<PostStatus>();
            PostStatusLastModifiedByMember = new HashSet<PostStatus>();
            PostStatusTypeCreatedByMember = new HashSet<PostStatusType>();
            PostStatusTypeLastModifiedByMember = new HashSet<PostStatusType>();
            PostTagCreatedByMember = new HashSet<PostTag>();
            PostTagLastModifiedByMember = new HashSet<PostTag>();
            PostTypeCreatedByMember = new HashSet<PostType>();
            PostTypeLastModifiedByMember = new HashSet<PostType>();
            PostVoteCreatedByMember = new HashSet<PostVote>();
            PostVoteLastModifiedByMember = new HashSet<PostVote>();
            PostVoteMember = new HashSet<PostVote>();
            PrivilegeCreatedByMember = new HashSet<Privilege>();
            PrivilegeLastModifiedByMember = new HashSet<Privilege>();
            SettingCreatedByMember = new HashSet<Setting>();
            SettingLastModifiedByMember = new HashSet<Setting>();
            SocialMediaTypeCreatedByMember = new HashSet<SocialMediaType>();
            SocialMediaTypeLastModifiedByMember = new HashSet<SocialMediaType>();
            TagCreatedByMember = new HashSet<Tag>();
            TagLastModifiedByMember = new HashSet<Tag>();
            TemplateCreatedByMember = new HashSet<Template>();
            TemplateLastModifiedByMember = new HashSet<Template>();
            TrustLevelCreatedByMember = new HashSet<TrustLevel>();
            TrustLevelLastModifiedByMember = new HashSet<TrustLevel>();
            VoteTypeCreatedByMember = new HashSet<VoteType>();
            VoteTypeLastModifeidByMember = new HashSet<VoteType>();
        }

        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public string DisplayName { get; set; }
        public string Bio { get; set; }
        public string ProfilePictureLink { get; set; }
        public bool IsTemporarilySuspended { get; set; }
        public DateTime? TemporarySuspensionEndAt { get; set; }
        public string TemporarySuspensionReason { get; set; }
        public long TrustLevelId { get; set; }
        public long? NetworkAccountId { get; set; }
        public bool IsModerator { get; set; }
        public bool IsAdministrator { get; set; }
        public bool? IsSyncedWithNetworkAccount { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual TrustLevel TrustLevel { get; set; }
        public virtual ICollection<Category> CategoryCreatedByMember { get; set; }
        public virtual ICollection<Category> CategoryLastModifiedByMember { get; set; }
        public virtual ICollection<CategoryPostType> CategoryPostTypeCreatedByMember { get; set; }
        public virtual ICollection<CategoryPostType> CategoryPostTypeLastModifiedByMember { get; set; }
        public virtual ICollection<Comment> CommentCreatedByMember { get; set; }
        public virtual ICollection<Comment> CommentLastModifiedByMember { get; set; }
        public virtual ICollection<Comment> CommentMember { get; set; }
        public virtual ICollection<CommentVote> CommentVoteCreatedByMember { get; set; }
        public virtual ICollection<CommentVote> CommentVoteLastModifiedByMember { get; set; }
        public virtual ICollection<CommentVote> CommentVoteMember { get; set; }
        public virtual ICollection<Member> InverseCreatedByMember { get; set; }
        public virtual ICollection<Member> InverseLastModifiedByMember { get; set; }
        public virtual ICollection<MemberPrivilege> MemberPrivilegeCreatedByMember { get; set; }
        public virtual ICollection<MemberPrivilege> MemberPrivilegeLastModifiedByMember { get; set; }
        public virtual ICollection<MemberPrivilege> MemberPrivilegeMember { get; set; }
        public virtual ICollection<MemberSocialMediaType> MemberSocialMediaTypeCreatedByMember { get; set; }
        public virtual ICollection<MemberSocialMediaType> MemberSocialMediaTypeLastModifiedByMember { get; set; }
        public virtual ICollection<MemberSocialMediaType> MemberSocialMediaTypeMember { get; set; }
        public virtual ICollection<Post> PostCreatedByMember { get; set; }
        public virtual ICollection<PostDuplicatePost> PostDuplicatePostCreatedByMember { get; set; }
        public virtual ICollection<PostDuplicatePost> PostDuplicatePostLastModifiedByMember { get; set; }
        public virtual ICollection<Post> PostLastModifiedByMember { get; set; }
        public virtual ICollection<Post> PostMember { get; set; }
        public virtual ICollection<PostStatus> PostStatusCreatedByMember { get; set; }
        public virtual ICollection<PostStatus> PostStatusLastModifiedByMember { get; set; }
        public virtual ICollection<PostStatusType> PostStatusTypeCreatedByMember { get; set; }
        public virtual ICollection<PostStatusType> PostStatusTypeLastModifiedByMember { get; set; }
        public virtual ICollection<PostTag> PostTagCreatedByMember { get; set; }
        public virtual ICollection<PostTag> PostTagLastModifiedByMember { get; set; }
        public virtual ICollection<PostType> PostTypeCreatedByMember { get; set; }
        public virtual ICollection<PostType> PostTypeLastModifiedByMember { get; set; }
        public virtual ICollection<PostVote> PostVoteCreatedByMember { get; set; }
        public virtual ICollection<PostVote> PostVoteLastModifiedByMember { get; set; }
        public virtual ICollection<PostVote> PostVoteMember { get; set; }
        public virtual ICollection<Privilege> PrivilegeCreatedByMember { get; set; }
        public virtual ICollection<Privilege> PrivilegeLastModifiedByMember { get; set; }
        public virtual ICollection<Setting> SettingCreatedByMember { get; set; }
        public virtual ICollection<Setting> SettingLastModifiedByMember { get; set; }
        public virtual ICollection<SocialMediaType> SocialMediaTypeCreatedByMember { get; set; }
        public virtual ICollection<SocialMediaType> SocialMediaTypeLastModifiedByMember { get; set; }
        public virtual ICollection<Tag> TagCreatedByMember { get; set; }
        public virtual ICollection<Tag> TagLastModifiedByMember { get; set; }
        public virtual ICollection<Template> TemplateCreatedByMember { get; set; }
        public virtual ICollection<Template> TemplateLastModifiedByMember { get; set; }
        public virtual ICollection<TrustLevel> TrustLevelCreatedByMember { get; set; }
        public virtual ICollection<TrustLevel> TrustLevelLastModifiedByMember { get; set; }
        public virtual ICollection<VoteType> VoteTypeCreatedByMember { get; set; }
        public virtual ICollection<VoteType> VoteTypeLastModifeidByMember { get; set; }
    }
}
