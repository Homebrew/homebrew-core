class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
      tag:      "v0.39.0",
      revision: "eafc6a36e7ff2df2b2cf3ebfa65b2ef514aee2ec"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c800b2645bf7ff81412e041bf6b66964473da3745d0f2625742aaea3101caabc"
    sha256 cellar: :any_skip_relocation, big_sur:       "944f236df1a80ff41fee765dbbc1d85c31d99259dbea6865c3523dd81a69fa33"
    sha256 cellar: :any_skip_relocation, catalina:      "03030e42e0268e6d94c71c3a8c2f55330fc326d041203208335cbc78cf8d8b2e"
    sha256 cellar: :any_skip_relocation, mojave:        "b08d59e515900ab6c677c645fd9aad644313ce9a0c8df1c72751f3a685ef593f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f5b7eaefbfe895d2f42304269b93a6b88ffb2141034a626891d695cb6c847f7"
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
