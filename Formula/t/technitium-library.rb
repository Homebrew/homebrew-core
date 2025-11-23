class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v14.2.0.tar.gz"
  sha256 "a87df80bccedb78af89c5fae022288475c1ade7723ae5c8cc9a43b545371db07"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "481cd1c6882f4e7faab4ea30bfe6d9c4572d029a3082bafed7eb2e1f26244179"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1b5fd36d027ad733344843614d31194e126807f9966433f3c5498fea185bbdb4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "294a3d23e359c562077075409fa93e7cdb70ee5db34fb3e11eb1cc5e9c0071cc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c7f7b355ecb321f1ad455ccaaf0962b8f19573d78f96ff12459a98d284d9fac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d679b1115d042f8c202f47fd6a0dfa97fb2decae3e57ceca0a5a53b56e01ffd2"
  end

  depends_on "dotnet"

  def install
    ENV["DOTNET_CLI_TELEMETRY_OPTOUT"] = "1"

    dotnet = Formula["dotnet"]
    args = %W[
      --configuration Release
      --framework net#{dotnet.version.major_minor}
      --no-self-contained
      --output #{libexec}
      --use-current-runtime
    ]

    system "dotnet", "publish", "TechnitiumLibrary.ByteTree/TechnitiumLibrary.ByteTree.csproj", *args
    system "dotnet", "publish", "TechnitiumLibrary.Net/TechnitiumLibrary.Net.csproj", *args
    system "dotnet", "publish", "TechnitiumLibrary.Security.OTP/TechnitiumLibrary.Security.OTP.csproj", *args
  end

  test do
    dotnet = Formula["dotnet"]
    target_framework = "net#{dotnet.version.major_minor}"

    (testpath/"test.cs").write <<~CSHARP
      using System;
      using TechnitiumLibrary;

      namespace Homebrew
      {
        public class TechnitiumLibraryTest
        {
          public static void Main(string[] args)
          {
            Console.WriteLine(Base32.ToBase32HexString(new byte[] { 1, 2, 3 }));
          }
        }
      }
    CSHARP

    (testpath/"test.csproj").write <<~XML
      <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
          <OutputType>Exe</OutputType>
          <TargetFrameworks>#{target_framework}</TargetFrameworks>
          <PlatformTarget>AnyCPU</PlatformTarget>
          <RootNamespace>Homebrew</RootNamespace>
          <PackageId>Homebrew.Dotnet</PackageId>
          <Title>Homebrew.Dotnet</Title>
          <Product>$(AssemblyName)</Product>
          <EnableDefaultCompileItems>false</EnableDefaultCompileItems>
        </PropertyGroup>
        <ItemGroup>
          <Compile Include="test.cs" />
        </ItemGroup>
        <ItemGroup>
          <Reference Include="TechnitiumLibrary">
            <HintPath>#{libexec}/TechnitiumLibrary.dll</HintPath>
          </Reference>
        </ItemGroup>
      </Project>
    XML

    system "#{dotnet.opt_libexec}/dotnet", "build", "--framework", target_framework,
           "--output", testpath, testpath/"test.csproj"
    output = shell_output("#{dotnet.opt_libexec}/dotnet run --framework #{target_framework} #{testpath}/test.dll")
    assert_match "04106===", output
  end
end
