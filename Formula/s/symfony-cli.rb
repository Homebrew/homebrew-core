class SymfonyCli < Formula
  desc "Build, run, and manage Symfony applications"
  homepage "https://symfony.com/download"
  url "https://github.com/symfony-cli/symfony-cli/archive/refs/tags/v5.18.1.tar.gz"
  sha256 "64d4292cce1f1bc0564cc6a9307dc5e61c75c271f739bef1f15aee2850301a44"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59dbf4189f1644a8a10d1f52e034a4fc539601da5f0870565963adbd4d9ac859"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe4944edda2d5378d4465ce2ca1563488c9be43f5f2d36acbd935d9ff67ba450"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "802c502679572d89f826694e10f58624690ccc233009c743ce8078846442b8d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fd8675a4f21c3b9021d59a1d30c5dc8a2f3a31bf94bdb8825df1d8c6e80126e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2abaa9a8719b509701d97811305e3144b9fb7262ef279482eca27bcfba0bfb0e"
    sha256 cellar: :any,                 x86_64_linux:  "14e4c17b232e201d44d9fb9a1ffd80d28db11b88e4dfe59199bf03e78dd12474"
  end

  depends_on "go" => :build
  depends_on "composer" => :test

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.buildDate=#{time.iso8601}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"symfony")

    generate_completions_from_executable(bin/"symfony", "self:completion")
  end

  service do
    run ["#{opt_bin}/symfony", "local:proxy:start", "--foreground"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/symfony self:version")

    system bin/"symfony", "new", "--no-git", testpath/"my_project"
    assert_path_exists testpath/"my_project/symfony.lock"
  end
end
