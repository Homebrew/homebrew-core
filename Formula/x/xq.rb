class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.5.1",
      revision: "9803fc9565174eacc844319409688172ce1412aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83f86d7fd6b23991856808a573ecf4fa085cad12de2ad9ab72a041b4cbc165b0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4af673959adac937d50059f1e5cb754e11c04a50bfca0ee47b19e7aa52006d85"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4af673959adac937d50059f1e5cb754e11c04a50bfca0ee47b19e7aa52006d85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "4af673959adac937d50059f1e5cb754e11c04a50bfca0ee47b19e7aa52006d85"
    sha256 cellar: :any_skip_relocation, sonoma:            "dbcc678d5b651a269af762a7c189715b7e725f3e0d2b06822ae2d5e4cb6d3e0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "633c44f3ea1de2cc6c748d3a8b50896720606a75d594510e123f317d9bc7eb7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f07e5e9a8140cd9e486d60cca64cb15f81aebf82ce268a499bd9e3e4ba84589b"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `xq` binaries"

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X main.commit=#{Utils.git_head}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags:)
    man1.install "docs/xq.man" => "xq.1"
  end

  test do
    version_output = shell_output("#{bin}/xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
