using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class PostStatusType
    {
        public PostStatusType()
        {
            PostStatus = new HashSet<PostStatus>();
        }

        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public string DisplayName { get; set; }
        public short? Description { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual ICollection<PostStatus> PostStatus { get; set; }
    }
}
