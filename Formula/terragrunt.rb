class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://github.com/gruntwork-io/terragrunt"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.16.11.tar.gz"
  sha256 "56796a49f923f6df0dcc664ac65156e34107fdfde993f8eb4537b33684999257"
  head "https://github.com/gruntwork-io/terragrunt.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f221350b7af850378a1ed675de27d82203474e9d58afb721118c9a96f6f8eec1" => :mojave
    sha256 "47ad4e44fba755a368063b01e196b098277b3d526e812c3f60a7ba3d553707ec" => :high_sierra
    sha256 "8ceadce52c3d6ec4c1e0c3046b964d9a3501ce1c38d88a96d58d5b5eb1140983" => :sierra
    sha256 "2a335f85ea2496ddafe6a58886c719391d6166c0b28fd246177c0e1476ae20b7" => :el_capitan
  end

  depends_on "glide" => :build
  depends_on "go" => :build
  depends_on "terraform"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    mkdir_p buildpath/"src/github.com/gruntwork-io/"
    ln_s buildpath, buildpath/"src/github.com/gruntwork-io/terragrunt"
    system "glide", "install"
    system "go", "build", "-o", bin/"terragrunt", "-ldflags", "-X main.VERSION=v#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
