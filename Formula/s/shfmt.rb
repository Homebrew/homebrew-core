class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/refs/tags/v3.13.0.tar.gz"
  sha256 "efef583999befd358fae57858affa4eb9dc8a415f39f69d0ebab3a9f473d7dd3"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daba25b6eaa9fad3fafd0cc18cdb1cff105c8a2f668425246d2d8ccfb27f0bea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "daba25b6eaa9fad3fafd0cc18cdb1cff105c8a2f668425246d2d8ccfb27f0bea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "daba25b6eaa9fad3fafd0cc18cdb1cff105c8a2f668425246d2d8ccfb27f0bea"
    sha256 cellar: :any_skip_relocation, sonoma:        "078f86b43cc4ebfe44586c7897954d9a17b2f4339742e3044a65ab53c23232ab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a0e8f15dca5f36dd316e1866fbb7d034216cbb8b5dd5d96c23d2034c07c92b49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "053eb1c7ea71daaa7b28649797289f69a59d4d39e3d30c19c81b46944bbe0da9"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -extldflags=-static"
    inreplace "cmd/shfmt/main.go", "version = mod.Version", "version = \"#{version}\""
    system "go", "build", *std_go_args(ldflags:), "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt --version")

    (testpath/"test").write "\t\techo foo"
    system bin/"shfmt", testpath/"test"
  end
end
