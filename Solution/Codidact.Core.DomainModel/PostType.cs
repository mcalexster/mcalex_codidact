using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class PostType
    {
        public PostType()
        {
            Post = new HashSet<Post>();
        }

        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public string DisplayName { get; set; }
        public string Description { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual ICollection<Post> Post { get; set; }
    }
}
