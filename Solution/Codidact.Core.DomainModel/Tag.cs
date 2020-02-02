using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class Tag
    {
        public Tag()
        {
            QuestionTag = new HashSet<QuestionTag>();
        }

        public int Id { get; set; }
        public int CommunityId { get; set; }
        public DateTime DatetimeCreated { get; set; }
        public string Title { get; set; }
        public string Description { get; set; }

        public virtual Community Community { get; set; }
        public virtual ICollection<QuestionTag> QuestionTag { get; set; }
    }
}
