class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.37.0",
      revision: "91942b68f203aa95e43dfa637165f0136a9343da"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "888eec8bd9ba5a1952404341dc87d059ad4d59690f01e484cf71ced962ddb426"
    sha256 cellar: :any_skip_relocation, big_sur:       "ebf0aa12f67169900431cbae74e7f574902569387d6af7a372d230957e39deac"
    sha256 cellar: :any_skip_relocation, catalina:      "608b56ac19d73d49ef7c11c7bfd7a2dc54feb1d568114e50a6ec6a1bd19e7ca2"
    sha256 cellar: :any_skip_relocation, mojave:        "530c1cc4504a5a7b3281cc7f398153041bbd4947cb036349568518b57bb4f1e7"
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
