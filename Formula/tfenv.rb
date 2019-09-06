class Tfenv < Formula
  desc "Terraform version manager inspired by rbenv"
  homepage "https://github.com/tfutils/tfenv"
  url "https://github.com/tfutils/tfenv/archive/v1.0.1.tar.gz"
  sha256 "8121f269a1c6214d7621a06e7f40e114e0a1c38a87d5b57585405aa4862ff0f0"
  head "https://github.com/tfutils/tfenv.git"

  bottle :unneeded

  conflicts_with "terraform", :because => "tfenv symlinks terraform binaries"

  def install
    prefix.install ["bin", "libexec", "share"]
  end

  test do
    system bin/"tfenv", "list-remote"
  end
end
