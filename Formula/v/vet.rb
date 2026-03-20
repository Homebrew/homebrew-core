class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://safedep.io/"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "5ea0a55b635352a42a48a9f0f6bce8f6f86471cee3cdcedca3a23d300c045987"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "daa628aab903fbfba1875cb00f6e4c9d0916b5d61015966bcfe9a95a72c847a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf7283bc581f4ca21ef0aec276c193deb831f7a4c8fd8141a068d9498b801ce1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7661c0eb08885c412dd35a099f58c516a05db642006106dca1967a0e7710b773"
    sha256 cellar: :any_skip_relocation, sonoma:        "0e56c2c284a2d30508c0d08de686abbf3a3aaf716420596740ab22658f11c1a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ef7a0b155245fb3666c25d1e087cf621ce9b0c79b5145e5faecc63d39ba80f66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "373239f66adf4d044d06d971297512339c2a586a4e3377980e0b31639f109ecd"
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
