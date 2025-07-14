class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.11.3.tar.gz"
  sha256 "ef406e7261fadf607fb729d415a0326055f9a07a5f9e5204b4645be4cc056920"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a80c7e166dc2fca8edfecf165d8e036f894ac028763442cf032e67206298b3d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "86272bd69bd91906bda06a79b306dfa38d6612c3bc925d1bab7b7e28a5365b61"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "11458d2191b6def533d242cbc9540e19ab9b65f9059fca5412ae7a23aa77a8eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb58110461a1027f588b00ce3d4198481a5e44ed8e081c7a8888c685a2096c22"
    sha256 cellar: :any_skip_relocation, ventura:       "db2a10e6d203fc02298678554ab0c23e802c74d66b25e750118e2dc0f26194cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "524db74bb3c22451041fcc99d75c50a8fc1dc0d1f9d4f32840f149985f83bb5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bacc09d33fa196574e6f1e92a54cc9602bdbd7698784aa758949b9a3c9cabd2d"
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
