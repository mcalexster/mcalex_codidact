using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class Comment
    {
        public Comment()
        {
            CommentVote = new HashSet<CommentVote>();
            InverseParentComment = new HashSet<Comment>();
        }

        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public long MemberId { get; set; }
        public long PostId { get; set; }
        public long? ParentCommentId { get; set; }
        public string Body { get; set; }
        public long Upvotes { get; set; }
        public long Downvotes { get; set; }
        public long? NetVotes { get; set; }
        public decimal Score { get; set; }
        public bool IsDeleted { get; set; }
        public DateTime? DeletedAt { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual Member Member { get; set; }
        public virtual Comment ParentComment { get; set; }
        public virtual Post Post { get; set; }
        public virtual ICollection<CommentVote> CommentVote { get; set; }
        public virtual ICollection<Comment> InverseParentComment { get; set; }
    }
}
