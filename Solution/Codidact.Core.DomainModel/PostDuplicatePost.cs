using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class PostDuplicatePost
    {
        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public long OriginalPostId { get; set; }
        public long DuplicatePostId { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Post DuplicatePost { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual Post OriginalPost { get; set; }
    }
}
