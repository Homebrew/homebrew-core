class UpdateNuspec < Formula
  desc "Sync NuGet dependencies in nuspec files from csproj PackageReference versions"
  homepage "https://github.com/denis-peshkov/update-nuspec-action"
  url "https://github.com/denis-peshkov/update-nuspec-action/releases/download/v2.0.154/update-nuspec-2.0.154-src.tar.gz"
  sha256 "7941053491da34444927fdb539e38db6286bcca253fa57ed66d66ba6096abfc3"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/update-nuspec --version")
  end
end
