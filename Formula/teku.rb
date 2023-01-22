class Teku < Formula
  desc "Java Implementation of the Ethereum 2.0 Beacon Chain"
  homepage "https://docs.teku.consensys.net/"
  url "https://github.com/ConsenSys/teku.git",
      tag:      "22.12.0",
      revision: "1a249bc53c52f8d7305224d80d55915aa949ce52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "629516a9c6ce06f1a68eabfbb7b6e71746fe91a6ed5e2017e6710a183e1995a8"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  # remove in next release
  patch do
    url "https://github.com/ConsenSys/teku/commit/090d88af628f39111b5fd5d7748ea16c7864d93f.patch?full_index=1"
    sha256 "217227146ade7b2c9bbff2e590bed0641ce59770974ad5d9998f88690259aec4"
  end

  # upsteam commit ref, https://github.com/ConsenSys/teku/commit/e791f5e88a85d4ea86f5eb810b21ecbbfd8282b1
  # remove in next release
  patch :DATA

  def install
    system "gradle", "installDist"

    libexec.install Dir["build/install/teku/*"]

    (bin/"teku").write_env_script libexec/"bin/teku", Language::Java.overridable_java_home_env
  end

  test do
    assert_match "teku/", shell_output("#{bin}/teku --version")

    rest_port = free_port
    fork do
      exec bin/"teku", "--rest-api-enabled", "--rest-api-port=#{rest_port}", "--p2p-enabled=false", "--ee-endpoint=http://127.0.0.1"
    end
    sleep 15

    output = shell_output("curl -sS -XGET http://127.0.0.1:#{rest_port}/eth/v1/node/syncing")
    assert_match "is_syncing", output
  end
end

__END__
diff --git a/gradle/versions.gradle b/gradle/versions.gradle
index c1916f59d..03e389f71 100644
--- a/gradle/versions.gradle
+++ b/gradle/versions.gradle
@@ -41,7 +41,7 @@ dependencyManagement {

     dependency 'io.libp2p:jvm-libp2p-minimal:0.10.0-RELEASE'
     dependency 'tech.pegasys:jblst:0.3.8'
-    dependency 'tech.pegasys:jc-kzg-4844:develop'
+    dependency 'tech.pegasys:jc-kzg-4844:0.1.0'

     dependency 'org.hdrhistogram:HdrHistogram:2.1.12'

diff --git a/infrastructure/kzg/src/main/java/tech/pegasys/teku/kzg/ckzg4844/CKZG4844.java b/infrastructure/kzg/src/main/java/tech/pegasys/teku/kzg/ckzg4844/CKZG4844.java
index 29d487223..24076a781 100644
--- a/infrastructure/kzg/src/main/java/tech/pegasys/teku/kzg/ckzg4844/CKZG4844.java
+++ b/infrastructure/kzg/src/main/java/tech/pegasys/teku/kzg/ckzg4844/CKZG4844.java
@@ -13,7 +13,9 @@

 package tech.pegasys.teku.kzg.ckzg4844;

-import ethereum.ckzg4844.CKzg4844JNI;
+import ethereum.ckzg4844.CKZG4844JNI;
+import ethereum.ckzg4844.CKZG4844JNI.Preset;
+import java.util.Arrays;
 import java.util.List;
 import java.util.stream.Stream;
 import org.apache.logging.log4j.LogManager;
@@ -40,7 +42,8 @@ public final class CKZG4844 implements KZG {

   public static synchronized CKZG4844 createInstance(final int fieldElementsPerBlob) {
     if (instance == null) {
-      instance = new CKZG4844();
+      final Preset preset = getPreset(fieldElementsPerBlob);
+      instance = new CKZG4844(preset);
       initializedFieldElementsPerBlob = fieldElementsPerBlob;
       return instance;
     }
@@ -58,9 +61,22 @@ public final class CKZG4844 implements KZG {
     return instance;
   }

-  private CKZG4844() {
+  private static Preset getPreset(final int fieldElementsPerBlob) {
+    return Arrays.stream(Preset.values())
+        .filter(preset -> preset.fieldElementsPerBlob == fieldElementsPerBlob)
+        .findFirst()
+        .orElseThrow(
+            () ->
+                new KZGException(
+                    String.format(
+                        "C-KZG-4844 library can't be initialized with %d fieldElementsPerBlob.",
+                        fieldElementsPerBlob)));
+  }
+
+  private CKZG4844(final Preset preset) {
     try {
-      LOG.debug("Loaded C-KZG-4844");
+      CKZG4844JNI.loadNativeLibrary(preset);
+      LOG.debug("Loaded C-KZG-4844 with {} preset", preset);
     } catch (final Exception ex) {
       throw new KZGException("Failed to load C-KZG-4844 library", ex);
     }
@@ -70,7 +86,7 @@ public final class CKZG4844 implements KZG {
   public void loadTrustedSetup(final String trustedSetup) throws KZGException {
     try {
       final String file = CKZG4844Utils.copyTrustedSetupToTempFileIfNeeded(trustedSetup);
-      CKzg4844JNI.loadTrustedSetup(file);
+      CKZG4844JNI.loadTrustedSetup(file);
       LOG.debug("Loaded trusted setup from {}", file);
     } catch (final Exception ex) {
       throw new KZGException("Failed to load trusted setup from " + trustedSetup, ex);
@@ -80,7 +96,7 @@ public final class CKZG4844 implements KZG {
   @Override
   public void freeTrustedSetup() throws KZGException {
     try {
-      CKzg4844JNI.freeTrustedSetup();
+      CKZG4844JNI.freeTrustedSetup();
     } catch (final Exception ex) {
       throw new KZGException("Failed to free trusted setup", ex);
     }
@@ -90,7 +106,7 @@ public final class CKZG4844 implements KZG {
   public KZGProof computeAggregateKzgProof(final List<Bytes> blobs) throws KZGException {
     try {
       final byte[] blobsBytes = CKZG4844Utils.flattenBytesList(blobs);
-      final byte[] proof = CKzg4844JNI.computeAggregateKzgProof(blobsBytes, blobs.size());
+      final byte[] proof = CKZG4844JNI.computeAggregateKzgProof(blobsBytes, blobs.size());
       return KZGProof.fromArray(proof);
     } catch (final Exception ex) {
       throw new KZGException("Failed to compute aggregated KZG proof for blobs", ex);
@@ -106,7 +122,7 @@ public final class CKZG4844 implements KZG {
       final Stream<Bytes> commitmentsBytesStream =
           kzgCommitments.stream().map(KZGCommitment::getBytesCompressed);
       final byte[] commitmentsBytes = CKZG4844Utils.flattenBytesStream(commitmentsBytesStream);
-      return CKzg4844JNI.verifyAggregateKzgProof(
+      return CKZG4844JNI.verifyAggregateKzgProof(
           blobsBytes, commitmentsBytes, blobs.size(), kzgProof.toArray());
     } catch (final Exception ex) {
       throw new KZGException(
@@ -117,7 +133,7 @@ public final class CKZG4844 implements KZG {
   @Override
   public KZGCommitment blobToKzgCommitment(final Bytes blob) throws KZGException {
     try {
-      final byte[] commitmentBytes = CKzg4844JNI.blobToKzgCommitment(blob.toArray());
+      final byte[] commitmentBytes = CKZG4844JNI.blobToKzgCommitment(blob.toArray());
       return KZGCommitment.fromArray(commitmentBytes);
     } catch (final Exception ex) {
       throw new KZGException("Failed to produce KZG commitment from blob", ex);
@@ -129,7 +145,7 @@ public final class CKZG4844 implements KZG {
       final KZGCommitment kzgCommitment, final Bytes32 z, final Bytes32 y, final KZGProof kzgProof)
       throws KZGException {
     try {
-      return CKzg4844JNI.verifyKzgProof(
+      return CKZG4844JNI.verifyKzgProof(
           kzgCommitment.toArray(), z.toArray(), y.toArray(), kzgProof.toArray());
     } catch (final Exception ex) {
       throw new KZGException(
