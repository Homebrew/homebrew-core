class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.15.0.tar.gz"
  sha256 "fff7ece99bad4f433da6e85ccc3dbda40ae35c698dd62789969ac30e8034907a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e6c16fe97fbeca9f6538e551dffb373b370937f164d0bc04d022a5fb76fa7cbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1010b10f31f6dc39f381ed01167d4fc67596afd349e09a4dc0f6d7f79ae4bc10"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "472d0ffca985be6201d4c5bfa93803055978c49adbe480a89ec9563fee7c8166"
    sha256 cellar: :any_skip_relocation, sonoma:        "a06ab8fc14977164886ac98956d8cc11b4321447a219e451e0c67cecc8235b9b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1e21d2be3b82dcaef9f07737b24e86ddb6f1f3aa3f6e324f0abf8cf77cdf719"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "939c835cbe8ad0005bee327fa396daac388bb670082c2306e502c3dbcdf20b0e"
  end

  depends_on "go"

  def install
    ENV["CGO_ENABLED"] = "1"
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
