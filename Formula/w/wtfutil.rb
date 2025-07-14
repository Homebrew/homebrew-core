class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "3134812d9b3a88b613922ea345aa36066e440d7b136cba548f560138f51f387b"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3bc4b5f411b9af37c7fdb0c7bfda50d9d5f1f425c208feb49cdf5453167331dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e8e26ed227be6e19ffd34490401f73830df0088cea69146a8d257d25d725f87"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c708ae2f78b021117175b5a4da396980e0f64f4b5997ee623ba932d8d4c7cbe8"
    sha256 cellar: :any_skip_relocation, sonoma:        "77c03aa4845b9f4060a0c7f4442b7bfe419c8d76b9876a38d43a8472c6d09f57"
    sha256 cellar: :any_skip_relocation, ventura:       "37789cf8079669e77d955e8a7c9bb194b5155efd586a4854f646ae87f38ee647"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dda404cff58b773d81fea45437b2d5c6b4915cac08041ee7248fae5f8cbdc5a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7297ea867c7032990b17f74768791b7ec7757e2085a40f9ead518df826d32a34"
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
