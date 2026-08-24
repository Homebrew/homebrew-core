class TechnitiumLibrary < Formula
  desc "Library for technitium .net based applications"
  homepage "https://technitium.com"
  url "https://github.com/TechnitiumSoftware/TechnitiumLibrary/archive/refs/tags/dns-server-v15.4.0.tar.gz"
  sha256 "b5d1c40706a4a06e3a971b384600ec9485b42fac453d4d5b42dd037e2cfa6f6a"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb4624d79ae517428b9d5691f71587397f85be92d6944a67de1f3c23b0153cc5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52796e370ecd99c323c63bbfa9c23b15106acb04160b5d6db147e3dd8b1aada2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "708debc8c4d65126c6516407ad86f379da1a227b55b02f8e49417e9dec1bcef1"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7f1b9eb05e56645e9560f6a55d4a6b04f6a5085fd7e6170c33ee8b47e079348"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b24f156a801d6489a1e9b22405ab7b4aa32a2febf7aa3e3373fe0b695d1aa78"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0f59f2513210acb988939cfc9ccc1d4b6be9dd6c23d8a55747295eabc957b4d6"
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
