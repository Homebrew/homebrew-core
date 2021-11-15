class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.40.0",
      revision: "f20465340a7937aa24b73f25fbf36cdccc415790"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa269f8f11c823a1bfb9bce0cf2f0d6b14e92f6d37bf4bfae640e681b21ee4d4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac63fe942934b8af64f084dda1386988322f4a46fe31b1895f101799fbf877c9"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ccd48fdef7ff5e979182bc53798fc995112fa3bbefabfe1c16d0f8f7427fd4"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d7ef886196dbaba38ba428a8ae8f39152175475701d89470e97e098eeb33dbe"
    sha256 cellar: :any_skip_relocation, catalina:       "9b0741c101bec126592e676fcdccd6d962a9b46962e01da7cea719d6b09d5aa4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0e0764599f54714457a3aa5e72a7b6176f7aa609e5fe6ea7c8b608024ad8820"
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
