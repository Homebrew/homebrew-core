class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "8f639957b6964a8afa104f4dcd151c08143fafe1832435fbfab15a6abdd701a4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7972b36137fd9ab2f77dd83288afef3438e88de4a3657ceb7897aaa737eedd3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc28e27e0c4baa179c80d7f715d47b5e9f5042920117f1de2918edb786459ac6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "70c9b936803bd56839ad2448bedf1d04ec1482b057f5cf3ba6a4bfa23fa1fa0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d12d497b0128bc2aa933927edc41d183dc448c077c250d445fef7592106fe70"
    sha256 cellar: :any_skip_relocation, ventura:       "171ddc008d44db530113d864446425620487083c5f2f830d7b22a0bdce3a7c03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65304ab901d30d4115b94390bcd569234a219f5da75cb91111937974e5d70e61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9ea0d20e0619d75fd1663a27514db4b2bf9d3f624208cdddebb65a9ba1caea8"
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
