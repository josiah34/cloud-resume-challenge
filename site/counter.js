const counter = document.querySelector('.counter-value');

async function updateCounter() {
  let response = await fetch('https://mwnbduxsvf3jrrcsakvk2oa7hq0jxfhh.lambda-url.us-east-1.on.aws/');
  let data = await response.json();
  counter.innerText = `${data}`;
  console.log(data);
}

updateCounter();
