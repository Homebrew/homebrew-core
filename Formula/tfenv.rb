class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/v1.0.0.tar.gz"
  sha256 "a05756db765903aad63c8ce7661c8006768937d1b1414b7e4913ed35012c4b4e"
  head "https://github.com/tfutils/tfenv.git"

  bottle :unneeded

  conflicts_with "terraform", :because => "tfenv symlinks terraform binaries"

  def install
    prefix.install ["bin", "libexec"]
  end

  test do
    system bin/"tfenv", "list-remote"
  end
end
