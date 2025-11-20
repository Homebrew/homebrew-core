class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/refs/tags/v0.47.1.tar.gz"
  sha256 "b03c8b12649d5b670a2786879379aa8e14bfaa67e583ab40774c12cca55e40ed"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "949e39a2866ee37c08749e0040547b32f651ead0b767ed1301e8eb6bccd32943"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "467577e76da166f028f2c4825a4142689774c383d2cd0dd41e2e1a5f214ea316"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f167b7fb0dfa35d8a7d8197e14163fe2101b8f7d04b6afb2c69289e0a2b6b2e9"
    sha256 cellar: :any_skip_relocation, sonoma:        "f38c145e35a97234371591084aa57f5fe5281bad88e9ed72538716a6cedbbb07"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "521f16af5fd9c981cca19aba74c71db04c2753e761d20ff4b4667da2b1ff841b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fad5a4811fa001e6dbdcd32f8c76f22912dc8f8f3e37ee6aaa8fe373475dc245"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    testconfig = testpath/"config.yml"
    testconfig.write <<~YAML
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
    YAML

    begin
      pid = fork do
        exec bin/"wtfutil", "--config=#{testconfig}"
      end
    ensure
      Process.kill("HUP", pid)
    end
  end
end
