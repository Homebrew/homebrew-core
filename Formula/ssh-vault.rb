class SshVault < Formula
  desc "encrypt/decrypt using ssh keys"
  homepage "https://ssh-vault.com/"
  url "https://github.com/ssh-vault/ssh-vault.git",
      :tag => "0.9.1",
      :revision => "ef5a4dfb4d2857b9586a27e96621a3bec576449a"

  head "https://github.com/ssh-vault/ssh-vault.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "179e07bb22e2755e3d082f07607cf2e98e266defaace3ceb764a4c32f03ccf8d" => :sierra
    sha256 "5be8ef01a8568b7de75b19d525a4830b0c934c43b9e8f9fb150cbdcb18091a26" => :el_capitan
    sha256 "6dcf9d7de2489f5e3d6fd56488c3abe2bff1ea6f6bf0d9de89421b0e9a7e2e38" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/ssh-vault/ssh-vault").install buildpath.children
    cd "src/github.com/ssh-vault/ssh-vault" do
      system "make"
      bin.install "ssh-vault"
    end
  end

  test do
    system bin/"ssh-vault", "-v"
  end
end
