class Threatcl < Formula
  desc "Documenting your Threat Models with HCL"
  homepage "https://github.com/threatcl/threatcl"
  url "https://github.com/threatcl/threatcl/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "d81b6685e709b1e039365143709466a7f6f330d1784769e027a6aa3417d56c81"
  license "MIT"
  head "https://github.com/threatcl/threatcl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd7de91e34c44844d03ca06dde47216b71f4352de60e25b91fa947cc972f39b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd7de91e34c44844d03ca06dde47216b71f4352de60e25b91fa947cc972f39b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd7de91e34c44844d03ca06dde47216b71f4352de60e25b91fa947cc972f39b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b613a61c0cdb9506b3a825ec3872ff4ccb89bf17fcab26dbf70c41292205385"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "41dd1d89ead1bff60feceb427205d011f1281c06f9f01c28f3f30a1f4bad837e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "21c803110441d27d7dbcbf4a050a0d5a1b2509bfbbe34c211551177d06991190"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = "-s -w -X github.com/threatcl/threatcl/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/threatcl"

    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples", testpath
    system bin/"threatcl", "list", "examples"

    output = shell_output("#{bin}/threatcl validate #{testpath}/examples")
    assert_match "[threatmodel: Modelly model]", output

    assert_match version.to_s, shell_output("#{bin}/threatcl --version 2>&1")
  end
end
