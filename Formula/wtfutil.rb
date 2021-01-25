class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.35.0",
      revision: "4b8b735a462e6fefa8e73dc36d68b89eb8986c12"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "d51620e6cf86db673ce46f663d332e113f06470b3ba276965ae779891b5c2437" => :big_sur
    sha256 "4f4c122267e04735a6529555cc70d14d3161e941509c54f552a11f6210c2f510" => :arm64_big_sur
    sha256 "7858804dd5d4555868d15c9fd83d150b980f611cff4731fc7ea004e505a44806" => :catalina
    sha256 "f3dcb23b05d19acdcd2f1511a193ceab69e45e18beb2a3c88c242dc9922459ea" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{Time.now.iso8601}
    ]
    system "go", "build", "-trimpath", "-ldflags", ldflags.join(" "), "-o", bin/"wtfutil"
  end

  test do
    testconfig = testpath/"config.yml"
    testconfig.write <<~EOS
      wtf:
        colors:
          background: "red"
          border:
            focusable: "darkslateblue"
            focused: "orange"
            normal: "gray"
          checked: "gray"
          highlight:
            fore: "black"
            back: "green"
          text: "white"
          title: "white"
        grid:
          # How _wide_ the columns are, in terminal characters. In this case we have
          # six columns, each of which are 35 characters wide
          columns: [35, 35, 35, 35, 35, 35]

          # How _high_ the rows are, in terminal lines. In this case we have five rows
          # that support ten line of text, one of three lines, and one of four
          rows: [10, 10, 10, 10, 10, 3, 4]
        navigation:
          shortcuts: true
        openFileUtil: "open"
        sigils:
          checkbox:
            checked: "x"
            unchecked: " "
          paging:
            normal: "*"
            selected: "_"
        term: "xterm-256color"
    EOS

    begin
      pid = fork do
        exec "#{bin}/wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end
