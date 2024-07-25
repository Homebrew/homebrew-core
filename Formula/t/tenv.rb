class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v2.7.7.tar.gz"
  sha256 "af0ed6e3e8242a1bf67e6de9daff8a202a121f2984e30d1d9879eeef1b04899e"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a1f21da245659a1932367d7ca05261f124a2f217668652dcb4c8f2dfb49874a0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1f21da245659a1932367d7ca05261f124a2f217668652dcb4c8f2dfb49874a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1f21da245659a1932367d7ca05261f124a2f217668652dcb4c8f2dfb49874a0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a8bf5d6603a2cfb7d942d4c4cab469e6340bde7ec3ff3a16d1923fac6e478d17"
    sha256 cellar: :any_skip_relocation, ventura:        "a8bf5d6603a2cfb7d942d4c4cab469e6340bde7ec3ff3a16d1923fac6e478d17"
    sha256 cellar: :any_skip_relocation, monterey:       "d1334cfa1dea0a387c9ac94708549eab3700d5b4cffb87967546e2f29baa0b91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9ccd5bec58bfa6aecf8076c843175a2f5e968380605033d72dc2757b826ccc9"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
