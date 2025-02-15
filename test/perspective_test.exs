defmodule Image.Perspective.Test do
  use ExUnit.Case, async: true
  import Image.TestSupport

  @warp_from [
    {139, 125},
    {826, 74},
    {796, 559},
    {155, 483}
  ]

  @warp_to [
    {139, 125},
    {815, 125},
    {815, 528},
    {139, 528}
  ]

  test "warps an image to perspective" do
    image_path = image_path("warp_perspective.jpg")
    validate_path = validate_path("warp/warp_perspective.jpg")

    {:ok, image} = Image.open(image_path)
    {:ok, result} = Image.warp_perspective(image, @warp_from, @warp_to)

    # Image.write! result, validate_path
    {:ok, result} = Vix.Vips.Image.write_to_buffer(result, ".jpg")

    assert_images_equal(result, validate_path)
  end

  test "warps an image to a rectangular perspective" do
    image_path = image_path("warp_perspective.jpg")
    validate_path = validate_path("warp/warp_perspective_straighten.png")

    {:ok, image} = Image.open(image_path)
    {:ok, destination, result} = Image.straighten_perspective(image, @warp_from)

    # Image.write! result, validate_path
    {:ok, result} = Vix.Vips.Image.write_to_buffer(result, ".png")

    assert [{139, 125}, {826, 125}, {826, 483}, {139, 483}] = destination
    assert_images_equal(result, validate_path)
  end

  test "post-crop of a warped image" do
    image_path = image_path("warp_perspective.jpg")
    validate_path = validate_path("warp/warp_perspective_cropped.png")

    {:ok, image} = Image.open(image_path)
    {:ok, result} = Image.warp_perspective(image, @warp_from, @warp_to)

    {:ok, cropped} = Image.crop(result, @warp_to)

    # Image.write! cropped, validate_path
    assert_images_equal(cropped, validate_path)
  end

  test "warp an image with an alpha band" do
    image_path = image_path("image_with_alpha2.png")
    validate_path = validate_path("warp/warped_image_with_alpha2.png")

    {:ok, image} = Image.open(image_path)
    {:ok, result} = Image.warp_perspective(image,
      [{139, 125}, {826, 74}, {796, 559}, {155, 483}],
      [{139, 125}, {815, 125}, {815, 528}, {139, 528}]
    )

    # Image.write! result, validate_path
    {:ok, result} = Vix.Vips.Image.write_to_buffer(result, ".png")

    assert_images_equal(result, validate_path)
  end

  test "warp an image with an alpha band making the added pixels transparent" do
    image_path = image_path("image_with_alpha2.png")
    validate_path = validate_path("warp/warped_image_with_alpha2_transparent.png")

    {:ok, image} = Image.open(image_path)
    {:ok, result} = Image.warp_perspective(image,
      [{139, 125}, {826, 74}, {796, 559}, {155, 483}],
      [{139, 125}, {815, 125}, {815, 528}, {139, 528}],
      background: [1, 177, 64]
    )
    {:ok, result} = Image.chroma_key(result, color: [1, 177, 64], threshold: 0)

    # Image.write! result, validate_path
    {:ok, result} = Vix.Vips.Image.write_to_buffer(result, ".png")

    assert_images_equal(result, validate_path)
  end
end
