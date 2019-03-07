class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.18.0.tar.gz"
  sha256 "5d5872ac317e42deb99c07b6666d40fa14b76032780ff48e719c4271d868beb8"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4649bf82fbf8997592b649e91e1a2bb7d25efa972789091dad9a8a1740d2b7cb" => :mojave
    sha256 "ac0313ed9e2e6c7042ba0ac134d439b216421c08fd80fe8f0c2f83ecca581d38" => :high_sierra
    sha256 "9a53cbaab8b28a8426a5aa57cda5de876eeb5da5d1c8fddc000cb60275aa578c" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/gruntwork-io/terragrunt").install buildpath.children
    cd "src/github.com/gruntwork-io/terragrunt" do
      system "dep", "ensure", "-vendor-only"
      system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
