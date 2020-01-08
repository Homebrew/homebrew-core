class Wtfutil < Formula
  desc "The personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf.git",
    :tag      => "v0.25.0",
    :revision => "5291a31afd9a525342ab62896423a00e06f3811f"

  bottle do
    cellar :any_skip_relocation
    sha256 "115fae9641bcc212efe42d3c802522891b75770035f0796fb1b12a6fa5a4dafb" => :catalina
    sha256 "a68a5f3dfe0cab3ed3097b3fe236760496a5615b35ac7d5dcc1fd4c4a0d600ee" => :mojave
    sha256 "5750ceac539222b235943f796a89c6da90836cf767f332e7db7fc2da3a942d60" => :high_sierra
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
