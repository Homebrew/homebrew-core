class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.26.0",
    :revision => "7ab898c718e693e76a930e334bb0c2836d4cf2d8"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "3530fb68726b77c8b208658935a292d5a1113334849f7d44e4eef573dafc9005" => :catalina
    sha256 "9cfb4c489cab85f60004101e33a285ac563e1559d5f154165420bca0d6e8906a" => :mojave
    sha256 "370a636a347fe12f069764168c9a73cc5b1e7dd11efe4eaccc3eb70a2eab4db8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPROXY"] = "https://gocenter.io"
    ldflags=["-s -w -X main.version=#{version}",
             "-X main.date=#{Time.now.iso8601}"]
    system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"wtfutil"
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
