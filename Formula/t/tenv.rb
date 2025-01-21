class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://github.com/tofuutils/tenv/archive/refs/tags/v4.1.0.tar.gz"
  sha256 "fc78224f2eae5fc529c862bc1cb1cbbe060e99f311446df665b58ce46fb6ba41"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d4c63fde7b1f516ecc7054c682f7baff43ccc7ba75c6a22b230e78cba079caf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d4c63fde7b1f516ecc7054c682f7baff43ccc7ba75c6a22b230e78cba079caf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d4c63fde7b1f516ecc7054c682f7baff43ccc7ba75c6a22b230e78cba079caf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1a42d6f6501580fe3ee76d2a24f69f6acdd1fccc46bbe7236aed3d134a87962"
    sha256 cellar: :any_skip_relocation, ventura:       "a1a42d6f6501580fe3ee76d2a24f69f6acdd1fccc46bbe7236aed3d134a87962"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e352e319845a6fa067e21a7b99531908b4d183a5070ee0bb5a5b1f36849914d"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", "tofuenv", because: "both install tofu binary"
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
