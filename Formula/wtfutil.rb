class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.23.0",
    :revision => "e98b15ca2cefddb285ad9d73b4fd2b35ca2c1d32"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac07538f6d6aca1cdcba7af5fe5f5a788671566cdc4d173483e352db0f935b73" => :catalina
    sha256 "c0aca34e02f80f79d4b00fd65d01af6e84d7b6be616420f551be068e94495c11" => :mojave
    sha256 "44279429caa2cc05d6af048268ed471aefa67846e1a1fd47ef1f6dd70dfbff44" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPROXY"] = "https://gocenter.io"
    system "go", "build", "-o", bin/"wtfutil"
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
