using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class VoteType
    {
        public VoteType()
        {
            CommentVote = new HashSet<CommentVote>();
            PostVote = new HashSet<PostVote>();
        }

        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifeidByMemberId { get; set; }
        public string DisplayName { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifeidByMember { get; set; }
        public virtual ICollection<CommentVote> CommentVote { get; set; }
        public virtual ICollection<PostVote> PostVote { get; set; }
    }
}
