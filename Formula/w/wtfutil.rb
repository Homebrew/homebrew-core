class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/refs/tags/v0.48.0.tar.gz"
  sha256 "89dc415d539bee6258a5c8886499203dea485cd5159f4c7cb07e28d03ab57931"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e30a514a165505b580a411f357a0860c98a30ea1c1b5b5f7f49296bd7b50bcbe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9adf648146e0cced4264447c38dd648e7631f9e55f348f9c3159c9ab3fcc0340"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e0d811e6c502935e25eafa35eb825fc741187c75c1511a379415ac7de0d6e830"
    sha256 cellar: :any_skip_relocation, sonoma:        "10215bfbd1d56581e71219902243c35e7e867ff3d9deabd595e0ed37cb675523"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1105694b80351da941a2fa885e8c0526b0488335a39b87a40731fb2826b359b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa509a37ecd204d633805c1eeed9fa71936b93bd546d2d0cef642b1247c1dc14"
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
