class SoqlMcp < Formula
  desc "MCP server for SOQL (Salesforce Object Query Language)"
  homepage "https://github.com/zhongxiao37/soql-mcp"
  url "https://github.com/zhongxiao37/soql-mcp.git",
      tag:      "v0.0.5",
      revision: "d6336f0f3061b747ce2bcbed97fd187236f58e0d"
  license "MIT"
  head "https://github.com/zhongxiao37/soql-mcp.git", branch: "main"

  depends_on "go" => :build

  def install
    mod = "github.com/zhongxiao37/soql-mcp"
    ldflags = %W[-w -s
                 -X #{mod}/pkg.Version=v#{version}
                 -X #{mod}/pkg.Commit=#{Utils.git_short_head(length: 7)}
                 -X #{mod}/pkg.BuildDate=#{time.iso8601}]
    system "go", "build", *std_go_args(ldflags:), "."
  end

  test do
    assert_match "soql-mcp", shell_output("#{bin}/soql-mcp --version")
  end
end
