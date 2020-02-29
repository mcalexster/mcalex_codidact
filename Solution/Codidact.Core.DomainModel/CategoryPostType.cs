using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class CategoryPostType
    {
        public long Id { get; set; }
        public DateTime CreatedAt { get; set; }
        public DateTime LastModifiedAt { get; set; }
        public long CreatedByMemberId { get; set; }
        public long LastModifiedByMemberId { get; set; }
        public long CategoryId { get; set; }
        public long PostTypeId { get; set; }
        public bool? IsActive { get; set; }

        public virtual Member CreatedByMember { get; set; }
        public virtual Member LastModifiedByMember { get; set; }
    }
}
