using System;
using System.Collections.Generic;

namespace Codidact.Core.WebApplication
{
    public partial class QuestionTag
    {
        public int QuestionId { get; set; }
        public int TagId { get; set; }

        public virtual Question Question { get; set; }
        public virtual Tag Tag { get; set; }
    }
}
