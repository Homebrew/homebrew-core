class Wtfutil < Formula
  desc "Personal information dashboard for your terminal"
  homepage "https://wtfutil.com"
  url "https://github.com/wtfutil/wtf/archive/refs/tags/v0.46.1.tar.gz"
  sha256 "89eb005075da7b6512b69e7829bfb1e54ca9cd838b735be2329fc083cd2b478a"
  license "MPL-2.0"
  head "https://github.com/wtfutil/wtf.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a35cfb1752e4dda75540d2455f74ee280d6120fb1da3d421c57b8dba946c3eb7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7980a2836088e8d64d02849a3660002c94d72c1b2363edc81805bb5b11225575"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd757c89df1f201fda050749f2df99fb1b9a05bf15f8eff0cd1a002045e29a25"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "da053d5d354886fbf75235f6a7edd85a1aec75d4ab4d9cc6f37104effc1748f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "08622dd3b50485323636c15054118bd9c2baf0409d832574a0b6ba5752432049"
    sha256 cellar: :any_skip_relocation, ventura:       "5c786973340be249e5473c5c17aecd297b090455a763a9e307bf1cd725d45633"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4bd66b539bc4f8b90eb565136eed64b547fc42114cd24eadf7c4eac396170218"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fe516e27b2a3a7fa2dda09ef06b14a5a9c7c378ee1c807bd2563ca50e9dec89"
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
