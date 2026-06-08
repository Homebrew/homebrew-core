class Talhelper < Formula
  desc "Configuration helper for talos clusters"
  homepage "https://budimanjojo.github.io/talhelper/latest/"
  url "https://github.com/budimanjojo/talhelper/archive/refs/tags/v3.1.10.tar.gz"
  sha256 "09ab65f61b319b2ad7285565304ef68ec49f2047936df63fc1bb760d049e9143"
  license "BSD-3-Clause"
  head "https://github.com/budimanjojo/talhelper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3f1ba9492e7fdf644b92af23ac75819d920c145c674f1bd63b1b5b45d2518298"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3f1ba9492e7fdf644b92af23ac75819d920c145c674f1bd63b1b5b45d2518298"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f1ba9492e7fdf644b92af23ac75819d920c145c674f1bd63b1b5b45d2518298"
    sha256 cellar: :any_skip_relocation, sonoma:        "55214d83a2d191e71a8ea90d308956182b323189753812c21f9276de044c2f51"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "57118c29ec6cb64a1e1ce83bcc73b4c1fc16b1ac6d80e31dbe739354818f3a74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dbe8f69c696bf092858ebc75dfc09262570d9fe76cc1d855db1d8a7b374f4bb4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/budimanjojo/talhelper/v#{version.major}/cmd.version=#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"talhelper", shell_parameter_format: :cobra)
    pkgshare.install "example"
  end

  test do
    cp_r Dir["#{pkgshare}/example/*"], testpath

    output = shell_output("#{bin}/talhelper genconfig 2>&1", 1)
    assert_match "failed to load env file: trying to decrypt talenv.yaml with sops", output

    assert_match "cluster:", shell_output("#{bin}/talhelper gensecret")

    assert_match version.to_s, shell_output("#{bin}/talhelper --version")
  end
end
