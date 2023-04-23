#! /usr/bin/python

from transformers import AutoTokenizer
from lightning_transformers.nlp.question_answering import QuestionAnsweringTransformer

pretrained_model=""
model = QuestionAnsweringTransformer(pretrained_model_name_or_path=pretrained_model, tokenizer = AutoTokenizer.from_pretrained(pretrained_model_name_or_path=pretrained_model) )

model.hf_predict(dict(context="I hate it when I get my fermions in a twist.", question="If you want to be a rigorous ass (I do), boiling is the region of phase phase where the free energy of a liquid suffers non analytic behavior between a gaseous and liquid phase. Basically it means large ensemble of water \"suddenly\" vaporizes when you increase the temp."))
