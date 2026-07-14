class UpdateNuspec < Formula
  desc "Sync NuGet dependencies in nuspec files from csproj PackageReference versions"
  homepage "https://github.com/denis-peshkov/update-nuspec-action"
  url "https://github.com/denis-peshkov/update-nuspec-action/releases/download/v2.0.150/update-nuspec-2.0.150-src.tar.gz"
  sha256 "f4c2feabc454c9adc4957fdd3d87d6fe6980bc22bdb4d9dda038c8eab63a51f3"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/update-nuspec --version")
  end
end
