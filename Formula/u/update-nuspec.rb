class UpdateNuspec < Formula
  desc "Sync NuGet dependencies in nuspec files from csproj PackageReference versions"
  homepage "https://github.com/denis-peshkov/update-nuspec-action"
  url "https://github.com/denis-peshkov/update-nuspec-action/releases/download/v2.0.142/update-nuspec-2.0.142-src.tar.gz"
  sha256 "570e20628d45e186eaa866cab7a85eb5502054637b1a2b6bf7c662ebab75acd2"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/update-nuspec --version")
  end
end
