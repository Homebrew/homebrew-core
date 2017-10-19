class Saml2aws < Formula
  desc "Login and retrieve AWS temporary credentials using a SAML IDP"
  homepage "https://github.com/Versent/saml2aws"
  url "https://github.com/Versent/saml2aws/archive/v1.8.4.tar.gz"
  sha256 "3561a58006a27e4e166e3798a2c38b5b4c746426e9a760e4fdb44cfe654a5098"

  depends_on "go" => :build
  depends_on "glide" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GLIDE_HOME"] = HOMEBREW_CACHE/"glide_home/#{name}"
    dir = buildpath/"src/github.com/versent/saml2aws"
    dir.install Dir["*"]
    cd dir do
      system "glide", "install"
      system "go", "build", "-o", bin/"saml2aws", "./cmd/saml2aws"
    end
  end

  test do
    system bin/"saml2aws", "--version"
  end
end
