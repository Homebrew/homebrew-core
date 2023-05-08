class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws.git",
      tag:      "v2.36.7",
      revision: "68d09f20dfde6bc617f1820850599b005a01c034"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67b747b0b9ede4a2e8b59e3412c5b80da25a54e65bfb2afa01cdbbd424acaf6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ced2e1f0851a98dfe442c0d9cea994858719d8d1c1b458ef7463b45d7bd867c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8a559f2278c6717de902892bed57c54c65c2a31aedaf0be8cd6e5d610102497"
    sha256 cellar: :any_skip_relocation, ventura:        "6185ee10651d8ab4bc66952b924479c4ca16d7998ee87d129efad18db5d177b3"
    sha256 cellar: :any_skip_relocation, monterey:       "963f703319e0635a805d39040c9f2d962fc059fbf65870dd2fe2e202f9505824"
    sha256 cellar: :any_skip_relocation, big_sur:        "45ad5658f64a39e6bcfc208f5fccd6abe81f8f1f298fef26425e39539bee9867"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0a29929a5cac740a42bee590ac646d46888eb3e3cf3574fba61ed4110ad0b82"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/saml2aws"
  end

  test do
    assert_match "error building login details: Failed to validate account.: URL empty in idp account",
      shell_output("#{bin}/saml2aws script 2>&1", 1)
  end
end
