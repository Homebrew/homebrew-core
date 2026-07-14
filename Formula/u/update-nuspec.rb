class UpdateNuspec < Formula
  desc "Sync NuGet dependencies in nuspec files from csproj PackageReference versions"
  homepage "https://github.com/denis-peshkov/update-nuspec-action"
  url "https://github.com/denis-peshkov/update-nuspec-action/releases/download/v2.0.141/update-nuspec-2.0.141-src.tar.gz"
  sha256 "987f81c166c33ff72639c5846d0e7db9fb6905ee440d6ba68ad5f49ec829059d"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/update-nuspec --version")
  end
end
