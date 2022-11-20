class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.42.0",
      revision: "a63329214c888cfbfc67c7ddcf31887c3c8a1c36"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29ce9ac3f0f4cd80a0f1d2bf2819c9c2b75313851bd0acac9a6c766c684bcaec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b03f60d91829e8d51c3ec2c0fb673754d5ca68472fc9ab0f23260e90e043ae74"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aed104aea6ffebb1ab51c69afbc75b3132c170f7d6d1779da1e24c6ce94e8717"
    sha256 cellar: :any_skip_relocation, ventura:        "12f44c076779562bb3a454496c5d582e4c1d4e6cf921d6f0fad48fe2b945f143"
    sha256 cellar: :any_skip_relocation, monterey:       "ff35df46d45719a6f42932ab619dad2ca2b287e89ef9fffbd4d682efaa65f6b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3e00f73dade6567164f653e0fc4cb81c3022d7b8734b224a50919f80881f71c"
    sha256 cellar: :any_skip_relocation, catalina:       "cc59ae72e2e6ce858e5b2135c5e372439eea14d99e763d429967d867c9707be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18896dc84daef54561d8a22833eca2b04a9345bf59bada7c43492d8bab5470ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags)
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
