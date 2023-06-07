class Xq < Formula
  desc "Command-line XML and HTML beautifier and content extractor"
  homepage "https://github.com/sibprogrammer/xq"
  url "https://github.com/sibprogrammer/xq.git",
      tag:      "v1.1.4",
      revision: "8aed2a2eaf2816d81bbd0b3a29d11de67d6b26ef"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9dc34c89f0eae9fc5e99e74cc5371068ee4e387a8bd48ea7501ed8ad7c329087"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9dc34c89f0eae9fc5e99e74cc5371068ee4e387a8bd48ea7501ed8ad7c329087"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9dc34c89f0eae9fc5e99e74cc5371068ee4e387a8bd48ea7501ed8ad7c329087"
    sha256 cellar: :any_skip_relocation, ventura:        "fa593c161af1f7bf8956707e10e48352a65b4d0138330ae33ad6003ce4603d6f"
    sha256 cellar: :any_skip_relocation, monterey:       "fa593c161af1f7bf8956707e10e48352a65b4d0138330ae33ad6003ce4603d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa593c161af1f7bf8956707e10e48352a65b4d0138330ae33ad6003ce4603d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9c16a8587bea8ef9f031609af55a7be9f7397cb71d907284c4d945603ec7c2f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.commit=#{Utils.git_head}
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "docs/xq.man" => "xq.1"
  end

  test do
    version_output = shell_output(bin/"xq --version 2>&1")
    assert_match "xq version #{version}", version_output

    run_output = pipe_output(bin/"xq", "<root></root>")
    assert_match("<root/>", run_output)
  end
end
