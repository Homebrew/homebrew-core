class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "f34f37f01e44db4b60ae0ec56524ffb8420b037d3f7ca6515b177a0b9b7789c2"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e56470f59b6f176883a2d18ccd1e089a480637b82fdc3ce8c60977697c7d5a43"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1424b2560d1c16aedec250f3fbf5de6b6c0b4b0eb969c75b44d6b8931c9b935a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "01dc0e8918d34779805aab6de96f2101cd3e21005ae3456c4372a8cb820b5ae6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c312809ed29beff62cecb05c7d929dc29fde3ec9c5ce682781f76282bee37093"
    sha256 cellar: :any,                 x86_64_linux:      "cc60dac6fb09a85ed7f6dda9e75d20b9345ed0ae2a60d024e2f291ca54ced68d"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = "-X main.version=#{version} -X main.date=#{time.iso8601}"
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
