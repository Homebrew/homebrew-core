class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.10.3.tar.gz"
  sha256 "8e5ce0c7cde44c113704a7ddeee54f8d63cf518605db9c3bd07423783ad7c7e2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "498f1476d53b45630fc071a988e68d282d310c0660f352fb7943f15f8952e883"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "691c421966dd4b0ff06cfd5e4c213784f5c17a9c7a03f87ddecabb3ef74d7b8a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db81cabb9d118f7f2c829de033f9619d4a1dbd23c4c25b4a61020b16d4b88a14"
    sha256 cellar: :any_skip_relocation, sonoma:        "78b9dbb4d1e7a3cccfeb419bb363b35171612582084de75480f436802413eeb7"
    sha256 cellar: :any_skip_relocation, ventura:       "f96ee0c7e580d822fbacb007494523cdbbdd9a52ba23963158512e427e8844a8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "30ba0971f998e46e7af64e799c3ca6adb0b264616ff975315acb2b2bf80d631a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "952e05a1915b263a0529c94c580d489343d5f58a1341662f6a819556d4829e70"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
