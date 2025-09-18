class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.12.5.tar.gz"
  sha256 "88617765c9f065702c71678149218d3a496ad4bf98824cc6cd17ff3e48c54251"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b959f8f40ee1de489c9879dacb3dcdbafecf0ce15aaaa7a1aafc16331a1b11f9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b261d9fe5e49dcab42d8a51f8125060b735df5d89cdfac5d861413bbf680778"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab0679ea977e4c3583926e053dd00ef91099e7303e188695cea519d1ce8aff39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b4c31fbaa75d07a3388e4aa547736903e076747324b7ab4309e83971fb5eb595"
    sha256 cellar: :any_skip_relocation, sonoma:        "8513d454834d887b46a7d9604442382eb47862c614ea279138df909b1a156ae9"
    sha256 cellar: :any_skip_relocation, ventura:       "6a441a144f7d17c4aa9f916b026f01c2ec8b3969e0bc68e05fc1f92daa48967b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "22dfd8002595fa54b23d047148a3e9be1f5329bdb2c9f452c0e6ef1f01d563c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8308f410221114860b93cc40dfb2989d35b4b6a316b1081022359163bd7f5db6"
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
