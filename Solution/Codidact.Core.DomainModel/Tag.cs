using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class Tag
    {
        public Tag()
        {
            InverseParentTag = new HashSet<Tag>();
            PostTag = new HashSet<PostTag>();
        }

        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public string Body { get; set; }
        public string Description { get; set; }
        public string TagWiki { get; set; }
        public bool? IsActive { get; set; }
        public long? SynonymTagId { get; set; }
        public long? ParentTagId { get; set; }
        public long Usages { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
        public virtual Tag ParentTag { get; set; }
        public virtual ICollection<Tag> InverseParentTag { get; set; }
        public virtual ICollection<PostTag> PostTag { get; set; }
    }
}
