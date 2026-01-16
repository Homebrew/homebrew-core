class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.3.0",
      revision: "86a755578f7bfb82fddc1f712c96db2f0bf36076"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "130ed5ae491d4df66e01950178196471a2c0aee6ecf92cfe547f505e096928fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acee76fdd23d919d0c9e3bee5ff519742be43f958833f8949972a48f222fb253"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acee76fdd23d919d0c9e3bee5ff519742be43f958833f8949972a48f222fb253"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "acee76fdd23d919d0c9e3bee5ff519742be43f958833f8949972a48f222fb253"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f27afa855799f0e43c3d7d878349dba62998d23a2504a3e0979998183b410e0"
    sha256 cellar: :any_skip_relocation, ventura:       "3f27afa855799f0e43c3d7d878349dba62998d23a2504a3e0979998183b410e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc8b386eb396c296d682edd48979979464ff7143b7d247fad0cd07e7c08e1954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3bfe60511be1ea50e381c53d56e8b7125315c189e3e7c23809c8eefa73df627"
  end

  depends_on "go" => :build

  conflicts_with "python-yq", because: "both install `xq` binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
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
